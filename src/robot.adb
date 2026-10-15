with Charger;
with Logger;
with Hub;
with Monitor;
package body Robot is
   task body Robot_Task is
      Finish : Boolean := False;
      Gen : Random.Generator;
      X : Zakres;
      Temp_Amount : Natural := 0;
      Is_Transporting : Boolean := False;
      Current_Product : Product_Type := Laptop;
      Current_Unloader : Unloading.Unloading_Access;
      Current_Amount : Natural := 0;
      Delivered : Natural := 0;
      Full_Amount : Natural := 0;
      Battery_Value : Natural := Max_Battery;
      procedure Decrease_Battery is
      begin
         Battery_Value := Battery_Value - Battery_Cost_Per_Stage;
         if Battery_Value <= Low_Battery_Threshold then
            Logger.Log (Module => 2, Sender => "Robot" &
            Robot_Id'Image (ID),
            Message => "Low battery, going to charge.");
            delay 5.0;
            Logger.Log (Module => 2, Sender => "Robot" &
            Robot_Id'Image (ID),
            Message => "Waiting to charge");
            Charger.Charge_Robot (ID, Battery_Value);
            Logger.Log (Module => 2, Sender => "Robot" &
            Robot_Id'Image (ID),
            Message => "Fully charged, going back to work.");
            Battery_Value := Global_Types.Max_Battery;
            delay 5.0;
         end if;
      end Decrease_Battery;
   begin
      Random.Reset (Gen);
      X := Random.Random (Gen);
      while not Finish loop
         if not Is_Transporting then
            select
               --  Geting new order
               accept Transport (
                     Product : Product_Type;
                     Unloader : Unloading.Unloading_Access
                  ) do
                     Current_Unloader := Unloader;
                     Current_Product := Product;
                     Current_Unloader.Check_Amount (Temp_Amount);
               end Transport;
               Is_Transporting := True;
            or
               accept Kill do
                  Finish := True;
               end Kill;
            or
               delay 2.0;
               Logger.Log (Module => 2, Sender => "Robot" &
               Robot_Id'Image (ID),
               Message => "Waiting for instructions ");
               if Is_Transporting then
                  Current_Unloader.Check_Amount (Temp_Amount);
               end if;
            end select;
         else
            select
               accept Kill do
                  Finish := True;
               end Kill;
            else
               Current_Unloader.Check_Amount (Temp_Amount);
               if Temp_Amount = 0 then
                  Logger.Log (Module => 2, Sender => "Robot" &
                  Robot_Id'Image (ID),
                  Message => "Unloader is empty");
                  delay Duration (X);
                  X := Random.Random (Gen);
               else
                  while Temp_Amount > 0 loop
                     --  Stage 1 - comming to the unloader
                     delay Duration (X);
                     X := Random.Random (Gen);
                     Decrease_Battery;
                     Logger.Log (Module => 2, Sender => "Robot" &
                     Robot_Id'Image (ID),
                     Message => "Comming to unloader nr." &
                     Unloader_Id'Image (Current_Unloader.ID) &
                     ". I must do " &
                     Natural'Image (Temp_Amount));
                     Monitor.Reporter.SetRobotStatus (
                        ID, Current_Amount, Battery_Value,
                        Delivered, Is_Transporting, Current_Product
                     );
                     --  Getting product from unloader
                     delay Duration (X);
                     X := Random.Random (Gen);
                     Decrease_Battery;
                     if Temp_Amount >= Hand_Size then
                        Current_Amount := Hand_Size;
                     else
                        Current_Amount := Temp_Amount;
                     end if;
                     Current_Unloader.Give_Product (
                        Amount_Taken => Positive (Current_Amount));
                     Monitor.Reporter.SetRobotStatus (
                        ID, Current_Amount, Battery_Value,
                        Delivered, Is_Transporting, Current_Product
                     );
                     --  Stage 2 - transporting product to the Hub
                     delay Duration (X);
                     X := Random.Random (Gen);
                     Decrease_Battery;
                     Logger.Log (Module => 2, Sender => "Robot" &
                     Robot_Id'Image (ID),
                     Message => "Transporting" &
                     Positive'Image (Hand_Size) &
                     " x " &
                     Product_Type'Image (Current_Product) &
                     " to Hub.");
                     Monitor.Reporter.SetRobotStatus (
                        ID, Current_Amount, Battery_Value,
                        Delivered, Is_Transporting, Current_Product
                     );
                     --  Stage 3 - Transport Completed
                     delay Duration (X);
                     X := Random.Random (Gen);
                     Decrease_Battery;
                     Hub.Hub_Task.Get (Product_gotten => Current_Product,
                     Count => Current_Amount);
                     Logger.Log (Module => 2, Sender => "Robot" &
                     Robot_Id'Image (ID),
                     Message => "Transported" &
                     Positive'Image (Current_Amount) &
                     " x " &
                     Product_Type'Image (Current_Product) &
                     " to Hub.");
                     Delivered := Delivered + Current_Amount;
                     Current_Unloader.Check_Amount (Temp_Amount);
                     Current_Unloader.Get_Full_Amount (Total => Full_Amount);
                     if Delivered >= Full_Amount then
                        Finish := True;
                        Temp_Amount := 0;
                        Logger.Log (Module => 2, Sender => "Robot" &
                        Robot_Id'Image (ID),
                        Message => "Unloader is empty");
                        Current_Unloader.Kill;
                     end if;
                     Monitor.Reporter.SetRobotStatus (
                        ID, Current_Amount, Battery_Value,
                        Delivered, Is_Transporting, Current_Product
                     );
                  end loop;
               end if;
            end select;
         end if;
      end loop;
      Logger.Log (Module => 2, Sender => "Robot" &
      Robot_Id'Image (ID),
      Message => "Turning off");
   end Robot_Task;
end Robot;