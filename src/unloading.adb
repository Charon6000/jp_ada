with Logger;

package body Unloading is
   task body Unloading_Task is
      Current_Delivery : Delivery;
      Has_Delivery : Boolean := False;
   begin
      loop
         select
            when not Has_Delivery =>
               accept New_Delivery (New_Delivery : Delivery) do
                  Logger.Log (Module => 1, Sender => "Unloading",
                  Message => "Starting to unload new delivery");
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
                  Current_Delivery.Amount := Current_Delivery.Amount - 1;
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