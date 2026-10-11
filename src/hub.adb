with Logger;

package body Hub is
   task body Hub_Task is
      --  constants
      Capacity : Natural := 0;
      Finish : Boolean := False;
      Max_In_Unloaders : Natural := 0;
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
            delay 2.0;
            Logger.Log (3, "Hub",
            "I have " &
            Natural'Image (Capacity) &
            " products on " & Natural'Image (Natural'Min(Max_Hub_Capacity, Max_In_Unloaders)));
         end select;
      end loop;
      Logger.Log (3, "Hub", "I am full");
   end Hub_Task;
end Hub;