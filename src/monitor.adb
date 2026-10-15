with Hub;
with Logger;
with Ada.Characters.Latin_1;
use Ada.Characters.Latin_1;
with Ada.Strings.Unbounded;
use Ada.Strings.Unbounded;
with Ada.Calendar;
use Ada.Calendar;

package body Monitor is
   task body Reporter is
      Trucks_List : Trucks := (others => null);
      Unloaders_List : Unloaders := (others => null);
      Robots_List : Robots;
      Robots_Found : array (Robot_Id) of Boolean := (others => False);
      Status : Hub_Status;
      TrucksString : Unbounded_String  := Null_Unbounded_String;
      TrucksStatus : Truck_Status;
      UnloaderString : Unbounded_String  := Null_Unbounded_String;
      UnloaderStatus : Unloader_Status;
      RobotString : Unbounded_String  := Null_Unbounded_String;
      Next_Report : Time := Clock + Report_Time;
   begin
         loop
            select
               accept AddTruck (ID : Truck_Id; T : Truck.Truck_Access) do
                  Trucks_List (ID) := T;
               end AddTruck;
            or
               accept AddUnloader (ID : Unloader_Id;
               U : Unloading.Unloading_Access) do
                  Unloaders_List (ID) := U;
               end AddUnloader;
            or
               accept SetRobotStatus (
                  ID : Robot_Id;
                  Current_Amount : Natural;
                  Battery_Value : Natural;
                  Delivered : Natural;
                  Is_Transporting : Boolean;
                  Current_Product : Product_Type)
               do
                  Robots_List (ID) := (ID              => ID,
                                      Current_Amount  => Current_Amount,
                                      Battery_Value   => Battery_Value,
                                      Delivered       => Delivered,
                                      Is_Transporting => Is_Transporting,
                                      Current_Product => Current_Product);
                  Robots_Found (ID) := True;
               end SetRobotStatus;
            or
               delay until Next_Report;
               Next_Report := Clock + Report_Time;
               Hub.Hub_Task.GetStatus (Status);
               TrucksString := Null_Unbounded_String;
               for I in  Truck_Id loop
                  if Trucks_List (I) /= null
                  and then Trucks_List (I)'Callable
                  then
                     Trucks_List (I).GetStatus (TrucksStatus);
                     TrucksString := TrucksString & LF &
                     "* Truck" & Truck_Id'Image (TrucksStatus.ID)
                     & LF & HT & "- Is_Unloading      " &
                     Boolean'Image (TrucksStatus.Is_Unloading)
                     & LF & HT & "- Waiting_Time      " &
                     Natural'Image (TrucksStatus.Waiting_Time)
                     & LF & HT & "- Remaining_Amount  " &
                     Natural'Image (TrucksStatus.Remaining_Amount);
                  end if;
               end loop;

               UnloaderString := Null_Unbounded_String;
               for I in  Unloader_Id loop
                  if Unloaders_List (I) /= null
                  and then Unloaders_List (I)'Callable
                  then
                     Unloaders_List (I).GetStatus (UnloaderStatus);
                     UnloaderString := UnloaderString & LF &
                     "* Unloader" & Unloader_Id'Image (UnloaderStatus.ID)
                     & LF & HT & "- Has_Delivery  "
                     & Boolean'Image (UnloaderStatus.Has_Delivery)
                     & LF & HT & "- Remaining_Amount  "
                     & Natural'Image (UnloaderStatus.Remaining_Amount);
                  end if;
               end loop;

               RobotString := Null_Unbounded_String;
               for I in  Robot_Id loop
                  if Robots_Found (I) then
                     Logger.Log_Raport ("Znalazlem robota " &
                     Robot_Id'Image (I));
                     RobotString := RobotString & LF &
                     "* Robot" & Robot_Id'Image (Robots_List (I).ID)
                     & LF & HT & "- Current_Amount  " &
                     Natural'Image (Robots_List (I).Current_Amount)
                     & LF & HT & "- Battery_Value  " &
                     Natural'Image (Robots_List (I).Battery_Value)
                     & LF & HT & "- Delivered  " &
                     Natural'Image (Robots_List (I).Delivered)
                     & LF & HT & "- Is_Transporting  " &
                     Boolean'Image (Robots_List (I).Is_Transporting)
                     & LF & HT & "- Current_Product  " &
                     Product_Type'Image (Robots_List (I).Current_Product);
                     Logger.Log_Raport ("Zakonczylem robota "
                     & Robot_Id'Image (I));
                  end if;
               end loop;

               Logger.Log_Raport (Message => ""
               & LF & "==========   Status   =========="
               & LF & "* HUB"
               & LF & HT & "- Laptops          " &
               Natural'Image (Status.Laptops)
               & LF & HT & "- TVs              " &
               Natural'Image (Status.TVs)
               & LF & HT & "- Washingmashines  " &
               Natural'Image (Status.Washingmashines)
               & LF & HT & "- Together         " &
               Natural'Image (Status.Together)
               & LF & HT & "- Max              " &
               Natural'Image (Status.Max)
               & To_String (TrucksString)
               & To_String (UnloaderString)
               & To_String (RobotString)
               & LF & "========   End Status   ========"
               & LF & "");
            end select;
         end loop;
   end Reporter;
end Monitor;