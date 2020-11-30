class AppUser{
    bool _isanonymous=false; 
    String id,username,mobileno,password; 
    AppUser({this.id,this.username,this.mobileno,this.password}); 
    AppUser.anonymous():this.username='Anonymous'{
        this._isanonymous=true; 
    }
    get anonymous=>this._isanonymous; 
    AppUser.fromMap(Map m){
        this.username = m['username']; 
        this.mobileno = m['mobileno'];  
        this.password=m['password']; 
    }
    
    toMap()=>{"username":username,"mobileno":mobileno,"password":password};
}