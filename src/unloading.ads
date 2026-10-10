with Global_Types;
use Global_Types;

package Unloading is
   task Unloading_Task is
      entry New_Delivery (New_Delivery : Delivery);
   end Unloading_Task;
end Unloading;