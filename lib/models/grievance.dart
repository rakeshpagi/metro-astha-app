class Grievance{
     String id, type, description ,date ; 
     Grievance(this.id,{this.type,this.description,this.date}); 

     toMap()=>{"gid":this.id,"gtype":this.type,"gdescription":description,"gdate":date};

     
}