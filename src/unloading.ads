with Truck;

package Unloading is
   task Unloading_Task is
      entry New_Delivery (New_Delivery : Truck.Truck_Access);
   end Unloading_Task;
end Unloading;