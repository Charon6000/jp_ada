with Global_Types;
use Global_Types;

package Charger is
   task Charger_Task is
      entry Podlacz (R_ID : in Robot_Id);
      entry Odlacz (R_ID : in Robot_Id);
   end Charger_Task;
end Charger;