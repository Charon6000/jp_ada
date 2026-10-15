with Global_Types;
use Global_Types;

package Hub is
   task Hub_Task is
      entry Get (
      Product_gotten : Product_Type;
      Count : Natural
      );
      entry Check_Capacity (Count : out Integer);
      entry Increase_Max(Count : Natural);
      entry GetStatus(OutStatus : out Hub_Status);
      entry Kill;
   end Hub_Task;
end Hub;