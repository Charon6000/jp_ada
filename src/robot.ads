with Global_Types;
use Global_Types;
with Unloading;

package Robot is
   task type Robot_Task (ID : Robot_Id; Hand_Size : Positive) is
      entry Transport (
         Product : Product_Type;
         Unloader : Unloading.Unloading_Access
      );
      entry Kill;
   end Robot_Task;
   type Robot_Access is access all Robot_Task;
end Robot;