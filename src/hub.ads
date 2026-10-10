with Global_Types;
use Global_Types;

package Hub is
   task Hub_Task is
      entry Get (Product : Product_Type; Count : Natural);
      entry Check_Capacity (Count : out Integer);
      entry Kill;
   end Hub_Task;
end Hub;