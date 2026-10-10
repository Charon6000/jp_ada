with Global_Types;
with Hub;
with Unloading;
with Truck;
--  Main procedure of the project
procedure jp_ada is
   --  Creating a truck pointer
   Simple_Truck : constant Truck.Truck_Access := new Truck.Truck_Task (
      ID => 1,
      Product => Global_Types.Laptop,
      Amount => 10
   );
begin
   --  Creating a Hub
   Hub.Hub_Task.Get (Global_Types.Laptop, 10);
   --  Giving Delivery to the unloader
   Unloading.Unloading_Task.New_Delivery (New_Delivery => Simple_Truck);
   --  Closing Objects
   Hub.Hub_Task.Kill;
end jp_ada;
