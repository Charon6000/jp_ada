with Global_Types;
use Global_Types;

package Truck is
   task type Truck_Task (
      ID : Truck_Id;
      Product : Product_Type;
      Amount : Natural
   ) is
   entry Start_Unloading;
   entry Give_Product (Amount_Taken : Positive);
   entry Check_Amount (Products_Amount : out Natural);
   entry GetStatus (OutStatus : out Truck_Status);
   end Truck_Task;
   type Truck_Access is access all Truck.Truck_Task;
end Truck;