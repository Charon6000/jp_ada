with Hub;
with Logger;
with Ada.Calendar;
use Ada.Calendar;
package body Unloading is
   task body Unloading_Task is
      --  Had to make access type for truck to change products amount
      Current_Delivery : Truck.Truck_Access;
      Has_Delivery : Boolean := False;
      Temp_Amount : Natural;
      Remaining_Amount : Natural := 0;
      Full_Amount : Natural;
      Next_Pull : Time := Clock + 2.0;
      Finish : Boolean := False;
   begin
      while not Finish loop
         select
            when not Has_Delivery =>
               accept New_Delivery (New_Delivery : Truck.Truck_Access) do
                  New_Delivery.Start_Unloading;
                  Hub.Hub_Task.Increase_Max (Count => New_Delivery.Amount);
                  Logger.Log (Module => 1, Sender => "Unloading" &
                  Unloader_Id'Image (ID),
                  Message => "Starting to unload " &
                  Truck_Id'Image (New_Delivery.ID) &
                  " delivery");
                  --  Maping Truck values on delivery
                  Current_Delivery := New_Delivery;
                  Full_Amount := Current_Delivery.Amount;
                  Has_Delivery := True;
               end New_Delivery;
         or
            when Remaining_Amount > 0 =>
               accept Give_Product (Amount_Taken : Positive) do
                  Remaining_Amount := Remaining_Amount - Amount_Taken;
                  Logger.Log (Module => 1, Sender => "Unloading" &
                  Unloader_Id'Image (ID),
                  Message => "Gave " & Positive'Image (Amount_Taken) &
                  " of " & Product_Type'Image (Current_Delivery.Product) &
                  " to robot");
               end Give_Product;
         or
            accept Get_Full_Amount (Total : out Natural) do
               Total := Full_Amount;
            end Get_Full_Amount;
         or
            accept Check_Amount(Current_Amount : out Natural) do
               Current_Amount := Remaining_Amount;
            end Check_Amount;
         or 
            accept Kill do
               Finish := True;
            end Kill;
         or
            delay until Next_Pull;
            Next_Pull := Clock + 2.0;
            if Has_Delivery then
               begin
                  Current_Delivery.Check_Amount (Temp_Amount);
               exception
                  when Tasking_Error => Temp_Amount := 0;
               end;
               if Temp_Amount > 0 then
                  if Temp_Amount >= Hand_Size then
                     Current_Delivery.Give_Product (Amount_Taken => Hand_Size);
                     Remaining_Amount := Remaining_Amount + Hand_Size;
                     Logger.Log (Module => 1, Sender => "Unloading" &
                     Unloader_Id'Image (ID),
                     Message => "Taking "& Product_Type'Image (Current_Delivery.Product)
                     & " x " & Positive'Image (Hand_Size) & ". Now have " &
                     Natural'Image (Remaining_Amount));
                  else
                     Current_Delivery.Give_Product (Amount_Taken => Positive (Temp_Amount));
                     Remaining_Amount := Remaining_Amount + Temp_Amount;
                     Logger.Log (Module => 1, Sender => "Unloading" &
                     Unloader_Id'Image (ID),
                     Message => "Taking "& Product_Type'Image (Current_Delivery.Product)
                     & " x " & Positive'Image (Temp_Amount) & ". Now have " &
                     Natural'Image (Remaining_Amount));
                  end if;
               else
                  Has_Delivery := False;
                  Logger.Log (Module => 1, Sender => "Unloading" &
                  Unloader_Id'Image (ID),
                  Message => "Closing delivery from truck " &
                  Truck_Id'Image (Current_Delivery.ID));
               end if;
            elsif Remaining_Amount = 0 then
               Logger.Log (Module => 1, Sender => "Unloading" &
               Unloader_Id'Image (ID),
               Message => "Waiting for new delivery");
            end if;
         end select;
      end loop;
   end Unloading_Task;
end Unloading;