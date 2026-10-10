with Logger;
package body Robot is
   task body Robot_Task is
      Finish : Boolean := False;
      Is_Transporting : Boolean := False;
      Gen : Random.Generator;
      X : Zakres;
   begin
      Random.Reset (Gen);
      while not Finish loop
         select
            when not Is_Transporting =>
               accept Transport (
                  Product : Product_Type;
                  Amount : Natural
               ) do
                  --  Stage 1 - comming to the unloader
                  Logger.Log (Module => 2, Sender => "Robot" &
                  Robot_Id'Image (ID),
                  Message => "Comming to unloader.");
                  X := Random.Random (Gen);
                  delay Duration (X);
                  --  Stage 2 - transporting product to the Hub
                  Logger.Log (Module => 2, Sender => "Robot" &
                  Robot_Id'Image (ID),
                  Message => "Transporting" &
                  Integer'Image (Amount) &
                  " x " &
                  Product_Type'Image (Product) &
                  " to Hub.");
                  X := Random.Random (Gen);
                  delay Duration (X);
                  --  Stage 3 - Transport Completed
                  Is_Transporting := False;
                  Logger.Log (Module => 2, Sender => "Robot" &
                  Robot_Id'Image (ID),
                  Message => "Transported" &
                  Integer'Image (Amount) &
                  " x " &
                  Product_Type'Image (Product) &
                  " to Hub.");
               end Transport;
         or
            accept Kill;
            Finish := True;
            Logger.Log (Module => 2, Sender => "Robot" &
            Robot_Id'Image (ID),
            Message => "Turning off");
         end select;
      end loop;
   end Robot_Task;
end Robot;