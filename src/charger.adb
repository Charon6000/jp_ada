with Ada.Text_IO;
with Logger;

package body Charger is
   --  Making an object for robots not to go at the same time
   protected Station is
      procedure Charge_Robot (ID : Global_Types.Robot_Id; Battery : Natural);
   end Station;

   protected body Station is
      procedure Charge_Robot (ID : Global_Types.Robot_Id; Battery : Natural) is
      begin
         Logger.Log_S (Module => "E", Sender => "Charger",
         Message => "Charging robot" & Global_Types.Robot_Id'Image (ID));
         delay Duration (Natural (Global_Types.Max_Battery - Battery)/10);
         Logger.Log_S (Module => "E", Sender => "Charger",
         Message => "Robot" & Global_Types.Robot_Id'Image (ID) & " is charged");
      end Charge_Robot;
   end Station;

   procedure Charge_Robot (ID : Global_Types.Robot_Id; Battery : Natural) is
   begin
      Station.Charge_Robot (ID, Battery);
   end Charge_Robot;
end Charger;