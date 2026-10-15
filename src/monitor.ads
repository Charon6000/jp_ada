with Truck;
use Truck;
with Unloading;
use Unloading;
with Global_Types;
use Global_Types;

package Monitor is
   type Trucks is array (Truck_Id) of Truck.Truck_Access;
   type Unloaders is array (Unloader_Id) of Unloading.Unloading_Access;
   type Robots is array (Robot_Id) of Robot_Status;
   task Reporter is
      entry AddTruck (ID : Truck_Id; T : Truck.Truck_Access);
      entry AddUnloader (ID : Unloader_Id; U : Unloading.Unloading_Access);
      entry SetRobotStatus (
         ID : Robot_Id;
         Current_Amount : Natural;
         Battery_Value : Natural;
         Delivered : Natural;
         Is_Transporting : Boolean;
         Current_Product : Product_Type
      );
   end Reporter;
end Monitor;