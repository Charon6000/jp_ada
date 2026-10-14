with Logger;
with Global_Types;
use Global_Types;

package body Charger is
   task body Charger_Task is
   begin 
      loop 
         accept Podlacz (R_ID : Robot_Id) do 
            Logger.log (
               Module => 5,
               Sender => "Charger",
               Message => "Podlaczono robota " & Robot_Id'Image(R_ID));
         end Podlacz;

         accept Odlacz (R_ID : Robot_Id) do 
            Logger.log (
               Module => 5,
               Sender => "Charger",
               Message => "Odlaczono robota " & Robot_Id'Image(R_ID));
         end Odlacz;
      end loop;
   end Charger_Task;
end Charger;
            