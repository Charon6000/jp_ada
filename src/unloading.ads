with Truck;
with Global_Types;
use Global_Types;

package Unloading is
   task type Unloading_Task (ID : Unloader_Id; Hand_Size : Positive) is
      entry New_Delivery (New_Delivery : Truck.Truck_Access);
      entry Check_Amount (Current_Amount : out Natural);
      entry Give_Product (Amount_Taken : Positive);
      entry Get_Full_Amount (Total : out Natural);
      entry GetStatus (OutStatus : out Unloader_Status);
      entry Kill;
   end Unloading_Task;
   type Unloading_Access is access all Unloading_Task;
end Unloading;