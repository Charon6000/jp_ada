with Hub;
with Logger;
with Ada.Characters.Latin_1;
use Ada.Characters.Latin_1;
with Ada.Strings.Unbounded;
use Ada.Strings.Unbounded;

package body Monitor is
   task body Reporter is
      Trucks_List : Trucks := (others => null);
      Unloaders_List : Unloaders := (others => null);
      Robots_List : Robots := (others => null);
      Status : Hub_Status;

      TrucksString : Unbounded_String  := Null_Unbounded_String;
      TrucksStatus : Truck_Status;
      begin
         loop
            select
               accept AddTruck (ID : Truck_Id; T : Truck.Truck_Access) do
                  Trucks_List(ID) := T;
               end AddTruck;
            or
               delay 5.0;
               Hub.Hub_Task.GetStatus (Status);
               TrucksString := Null_Unbounded_String;
               for I in  Truck_Id loop
                  if Trucks_List(I) /= null and then Trucks_List(I)'Callable then
                     Trucks_List(I).GetStatus (TrucksStatus);
                     TrucksString := TrucksString & LF & "* Truck" & Truck_Id'Image (TrucksStatus.ID)
                     & LF & HT &"- Is_Unloading      " & Boolean'Image (TrucksStatus.Is_Unloading)
                     & LF & HT &"- Waiting_Time      " & Natural'Image (TrucksStatus.Waiting_Time)
                     & LF & HT &"- Remaining_Amount  " & Natural'Image (TrucksStatus.Remaining_Amount);
                  end if;
               end loop;
               Logger.Log_Raport (Message => ""
               & LF & "==========   Status   =========="
               & LF & "* HUB"
               & LF & HT &"- Laptops          " & Natural'Image (Status.Laptops)
               & LF & HT &"- TVs              " & Natural'Image (Status.TVs)
               & LF & HT &"- Washingmashines  " & Natural'Image (Status.Washingmashines)
               & LF & HT &"- Together         " & Natural'Image (Status.Together)
               & LF & HT &"- Max              " & Natural'Image (Status.Max)
               & To_String (TrucksString)
               & LF & "========   End Status   ========"
               & LF & "");
            end select;
         end loop;
   end Reporter;
end Monitor;