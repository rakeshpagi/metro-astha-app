class AppUser{
    bool _isanonymous=false; 
    String id,username,mobileno; 
    AppUser({this.id,this.username,this.mobileno}); 
    AppUser.anonymous():this.username='Anonymous'{
        this._isanonymous=true; 
    }
    get anonymous=>this._isanonymous; 
    AppUser.fromMap(Map m){
        this.username = m['username']; 
        this.mobileno = m['mobileno'];  
    }
    
    toMap()=>{"username":username,"mobileno":mobileno};
}