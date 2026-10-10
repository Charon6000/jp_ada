with Logger;
package body Truck is
   task body Truck_Task is
      Is_Unloading : Boolean := False;
      Waiting_Time : Natural := 0;
      Remaining_Amount : Natural := Amount;
   begin
      Logger.Log (Module => 1, Sender => "Truck",
      Message => "Starting with delivery number" &
      Truck_Id'Image (ID));
      loop
         if Waiting_Time > Max_Truck_Waiting_Time then
            Logger.Log (Module => 1, Sender => "Truck",
            Message => "Waited too long, running away.");
            exit;
         elsif Remaining_Amount = 0 then
            Logger.Log (Module => 1, Sender => "Truck",
            Message => "Empty,  running away.");
            exit;
         end if;
         select
            accept Give_Product (Amount_Taken : Positive) do
               Remaining_Amount := Remaining_Amount - Amount_Taken;
               Logger.Log (Module => 1, Sender => "Truck",
               Message => "Gave " & Positive'Image (Amount_Taken) &
               " of " & Product_Type'Image (Product) &
               " to unloader");
            end Give_Product;
         or
            accept Start_Unloading;
            delay 3.0;
            Is_Unloading := True;
            Waiting_Time := 0;
            Logger.Log (Module => 1, Sender => "Truck",
            Message => "Is being unloaded");
         else
            if not Is_Unloading then
               delay 3.0;
               Logger.Log (Module => 1, Sender => "Truck",
               Message => "Looking for unloader");
               Waiting_Time := Waiting_Time + 3;
            end if;
         end select;
      end loop;
   end Truck_Task;
end Truck;