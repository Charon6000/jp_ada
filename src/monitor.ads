with Robot;
with Truck;
use Truck;
with Unloading;
with Global_Types;
use Global_Types;

package Monitor is
   type Trucks is array(Truck_Id) of Truck.Truck_Access;
   type Unloaders is array(Unloader_Id) of Unloading.Unloading_Access;
   type Robots is array(Robot_Id) of Robot.Robot_Access;
   task Reporter is
      entry AddTruck(ID : Truck_Id; T : Truck.Truck_Access);
   end Reporter;
end Monitor;