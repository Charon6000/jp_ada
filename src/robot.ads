with Global_Types;
use Global_Types;

package Robot is
   task type Robot_Task (ID : Robot_Id) is
      entry Transport (
         Product : Product_Type;
         Amount : Natural
      );
      entry Kill;
   end Robot_Task;
end Robot;