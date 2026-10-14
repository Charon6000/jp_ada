with Logger;
with Hub;
with Charger;

package body Robot is

   procedure Consume_Battery (Battery : in out Natural) is
   begin
      if Battery >= Battery_Cost_Per_Stage then
         Battery := Battery - Battery_Cost_Per_Stage;
      else
         Battery := 0;
      end if;
   end Consume_Battery;

   procedure Recharge (ID : Robot_Id; Battery : in out Natural) is
   begin
      Logger.Log (
         Module  => 2,
         Sender  => "Robot" & Robot_Id'Image (ID),
         Message =>
            "Niski poziom baterii ("
            & Natural'Image (Battery)
            & "), jade do ladowarki");

      Logger.Log (
         Module  => 5,
         Sender  => "Robot" & Robot_Id'Image (ID),
         Message => "Oczekuje na ladowarke");

      Charger.Charger_Task.Podlacz (R_ID => ID);

      while Battery < Max_Battery loop
         delay 1.0;
         if Battery + Battery_Charge_Per_Tick >= Max_Battery then
            Battery := Max_Battery;
         else
            Battery := Battery + Battery_Charge_Per_Tick;
         end if;
      end loop;

      Charger.Charger_Task.Odlacz (R_ID => ID);

      Logger.Log (
         Module  => 2,
         Sender  => "Robot" & Robot_Id'Image (ID),
         Message =>
            "Bateria naladowana do " & Natural'Image (Battery));
   end Recharge;

   task body Robot_Task is
      Finish          : Boolean := False;
      Gen             : Random.Generator;
      X               : Zakres;
      Temp_Amount     : Natural := 0;
      Is_Transporting : Boolean := False;
      Current_Product : Product_Type;
      Current_Unloader : Unloading.Unloading_Access;
      Current_Amount  : Natural := 0;
      Delivered       : Natural := 0;
      Full_Amount     : Natural := 0;
      Battery         : Natural := Max_Battery;
   begin
      Random.Reset (Gen);
      X := Random.Random (Gen);

      while not Finish loop
         if not Is_Transporting then
            select
               accept Transport (
                  Product  : Product_Type;
                  Unloader : Unloading.Unloading_Access
               ) do
                  Current_Unloader := Unloader;
                  Current_Product  := Product;
                  Current_Unloader.Check_Amount (Temp_Amount);
               end Transport;
               Is_Transporting := True;
            or
               accept Kill do
                  Finish := True;
               end Kill;
            or
               delay 2.0;
               Logger.Log (
                  Module  => 2,
                  Sender  => "Robot" & Robot_Id'Image (ID),
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
               if Battery <= Low_Battery_Threshold then
                  Recharge (ID, Battery);
               end if;

               Current_Unloader.Check_Amount (Temp_Amount);

               if Temp_Amount = 0 then
                  Logger.Log (
                     Module  => 2,
                     Sender  => "Robot" & Robot_Id'Image (ID),
                     Message => "Unloader is empty");
                  delay Duration (X);
                  Consume_Battery (Battery);
                  X := Random.Random (Gen);
               else
                  while Temp_Amount > 0 and not Finish loop
                     if Battery <= Low_Battery_Threshold then
                        Recharge (ID, Battery);
                     end if;

                     delay Duration (X);
                     Consume_Battery (Battery);
                     X := Random.Random (Gen);
                     Logger.Log (
                        Module  => 2,
                        Sender  => "Robot" & Robot_Id'Image (ID),
                        Message =>
                           "Comming to unloader nr."
                           & Unloader_Id'Image (Current_Unloader.ID)
                           & ". I must do "
                           & Natural'Image (Temp_Amount));

                     if Battery <= Low_Battery_Threshold then
                        Recharge (ID, Battery);
                     end if;

                     delay Duration (X);
                     Consume_Battery (Battery);
                     X := Random.Random (Gen);

                     if Temp_Amount >= Hand_Size then
                        Current_Amount := Hand_Size;
                     else
                        Current_Amount := Temp_Amount;
                     end if;
                     Current_Unloader.Give_Product (
                        Amount_Taken => Positive (Current_Amount));

                     if Battery <= Low_Battery_Threshold then
                        Recharge (ID, Battery);
                     end if;

                     delay Duration (X);
                     Consume_Battery (Battery);
                     X := Random.Random (Gen);
                     Logger.Log (
                        Module  => 2,
                        Sender  => "Robot" & Robot_Id'Image (ID),
                        Message =>
                           "Transporting"
                           & Positive'Image (Hand_Size)
                           & " x "
                           & Product_Type'Image (Current_Product)
                           & " to Hub.");

                     if Battery <= Low_Battery_Threshold then
                        Recharge (ID, Battery);
                     end if;

                     delay Duration (X);
                     Consume_Battery (Battery);
                     X := Random.Random (Gen);

                     Hub.Hub_Task.Get (
                        Product_gotten => Current_Product,
                        Count          => Current_Amount);

                     Logger.Log (
                        Module  => 2,
                        Sender  => "Robot" & Robot_Id'Image (ID),
                        Message =>
                           "Transported"
                           & Positive'Image (Current_Amount)
                           & " x "
                           & Product_Type'Image (Current_Product)
                           & " to Hub.");

                     Delivered := Delivered + Current_Amount;
                     Current_Unloader.Check_Amount (Temp_Amount);
                     Current_Unloader.Get_Full_Amount (Total => Full_Amount);

                     if Delivered >= Full_Amount then
                        Finish      := True;
                        Temp_Amount := 0;
                        Logger.Log (
                           Module  => 2,
                           Sender  => "Robot" & Robot_Id'Image (ID),
                           Message => "Unloader is empty");
                        Current_Unloader.Kill;
                     end if;
                  end loop;
               end if;
            end select;
         end if;
      end loop;

      Logger.Log (
         Module  => 2,
         Sender  => "Robot" & Robot_Id'Image (ID),
         Message => "Turning off");
   end Robot_Task;

end Robot;