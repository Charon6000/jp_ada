with Logger;
with Ada.Characters.Latin_1;
use Ada.Characters.Latin_1;

package body Hub is
   task body Hub_Task is
      --  constants
      Capacity : Natural := 0;
      Finish : Boolean := False;
      Max_In_Unloaders : Natural := 0;
      Status : Hub_Status := (Laptops => 0, TVs => 0, Washingmashines => 0, Together => 0, Max => 0);
   begin
      --  behaviour
      while not Finish loop
         select
            when Capacity < Max_Hub_Capacity and Capacity < Max_In_Unloaders =>
               accept Get (
                  Product_gotten : Product_Type;
                  Count : Natural
               ) do
                  --  Alire hates long lines
                  Logger.Log (3, "Hub",
                  "Got delivery of " &
                  Integer'Image (Count) &
                  " x " &
                  Product_Type'Image (Product_gotten) &
                  " products");
                  Capacity := Capacity + Count;
                  if Product_gotten = Laptop then
                     Status.Laptops := Status.Laptops + Count;
                  elsif Product_gotten = Pralka then
                     Status.Washingmashines := Status.Washingmashines + Count;
                  elsif Product_gotten = Telewizor then
                     Status.TVs := Status.TVs + Count;
                  end if;
                  if Capacity >= Max_Hub_Capacity or Capacity >= Max_In_Unloaders then
                     Finish := True;
                  end if;
               end Get;
         or
            accept Check_Capacity (
               Count : out Integer
            ) do
               Count := Capacity;
            end Check_Capacity;
         or
            accept Increase_Max(Count : Natural) do
               Max_In_Unloaders :=  Max_In_Unloaders + Count;
            end Increase_Max;
         or
            accept GetStatus (OutStatus : out Hub_Status) do
               Status.Together := Capacity;
               Status.Max := Natural'Min (Max_In_Unloaders, Max_Hub_Capacity);
               OutStatus := Status;
            end GetStatus;
         or
            accept Kill;
            Finish := True;
         end select;
      end loop;
      Logger.Log (3, "Hub", "I am full");
      Status.Together := Capacity;
      Status.Max := Natural'Min (Max_In_Unloaders, Max_Hub_Capacity);
   end Hub_Task;
end Hub;