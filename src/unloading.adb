with Global_Types;
use Global_Types;
with Logger;
package body Unloading is
   task body Unloading_Task is
      --  Had to make access type for truck to change products amount
      Current_Delivery : Truck.Truck_Access;
      Has_Delivery : Boolean := False;
      Temp_Amount : Natural;
   begin
      loop
         select
            when not Has_Delivery =>
               accept New_Delivery (New_Delivery : Truck.Truck_Access) do
                  Logger.Log (Module => 1, Sender => "Unloading",
                  Message => "Starting to unload " &
                  Truck_Id'Image (New_Delivery.ID) &
                  " delivery");
                  New_Delivery.Start_Unloading;
                  --  Maping Truck values on delivery
                  Current_Delivery := New_Delivery;
                  Has_Delivery := True;
               end New_Delivery;
         or
            when Has_Delivery =>
               --  Looking for free robot and giving him a product
               delay 2.0;
               if Current_Delivery.Amount > 0 then
                  Logger.Log (Module => 1, Sender => "Unloading",
                  Message => "Giving product to the robot.");
                  Current_Delivery.Check_Amount (Temp_Amount);
                  if Temp_Amount >= Hand_Size then
                     Current_Delivery.Give_Product (Amount_Taken => Hand_Size);
                  else
                     Current_Delivery.Give_Product (Amount_Taken => Positive (Temp_Amount));
                  end if;
               else
                  Has_Delivery := False;
                  Logger.Log (Module => 1, Sender => "Unloading",
                  Message => "Closing delivery from truck " &
                  Truck_Id'Image (Current_Delivery.ID));
               end if;
         or
            delay 3.0;
            Logger.Log (Module => 1, Sender => "Unloading",
            Message => "Waiting for new delivery");
         end select;
      end loop;
   end Unloading_Task;
end Unloading;