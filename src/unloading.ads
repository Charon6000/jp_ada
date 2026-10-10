with Truck;
package Unloading is
   task type Unloading_Task (ID : Natural) is
      entry New_Delivery (New_Delivery : Truck.Truck_Access);
   end Unloading_Task;
end Unloading;