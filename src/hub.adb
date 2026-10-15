with Logger;
with Ada.Characters.Latin_1;
use Ada.Characters.Latin_1;

package body Hub is
   procedure SayStatus (Status : Hub_Status) is
      Raport : String := ""
      & LF & "==========   Status   =========="
      & LF & "- Laptops          " & Natural'Image (Status.Laptops)
      & LF & "- TVs              " & Natural'Image (Status.TVs)
      & LF & "- Washingmashines  " & Natural'Image (Status.Washingmashines)
      & LF & "- Together         " & Natural'Image (Status.Together)
      & LF & "- Max              " & Natural'Image (Status.Max)
      & LF & "========   End Status   ========"
      & LF & "";
   begin
      Logger.Log_Raport (Message => Raport);
   end SayStatus;

   task body Hub_Task is
      --  constants
      Capacity : Natural := 0;
      Finish : Boolean := False;
      Max_In_Unloaders : Natural := 0;
      Status : Hub_Status;
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
            accept Kill;
            Finish := True;
         or
            delay 4.0;
            Status.Together := Capacity;
            Status.Max := Natural'Min (Max_In_Unloaders, Max_Hub_Capacity);
            SayStatus (Status);
         end select;
      end loop;
      Logger.Log (3, "Hub", "I am full");
      Status.Together := Capacity;
      Status.Max := Natural'Min (Max_In_Unloaders, Max_Hub_Capacity);
      SayStatus (Status);
   end Hub_Task;
end Hub;