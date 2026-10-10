with Logger;

package body Hub is
   task body Hub_Task is
      --  constants
      Capacity : Natural := 0;
      Finish : Boolean := False;
   begin
      --  behaviour
      while not Finish loop
         select
            when Capacity < Max_Hub_Capacity =>
               accept Get (
                  Product : Product_Type;
                  Count : Natural
               ) do
                  Capacity := Capacity + Count;
                  --  Alire hates long lines
                  Logger.Log (3, "Hub",
                  "Got delivery of " &
                  Integer'Image (Capacity) &
                  " x " &
                  Product_Type'Image (Product) &
                  " products");
               end Get;
         or
            accept Check_Capacity (
               Count : out Integer
            ) do
               Count := Capacity;
            end Check_Capacity;
         or
            accept Kill;
            Finish := True;
         end select;
      end loop;
   end Hub_Task;
end Hub;