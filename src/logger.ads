package Logger is
   procedure Log (Module : Integer; Sender : String; Message : String);
   procedure Log_Raport (Header : String; Message : String);
private
end Logger;