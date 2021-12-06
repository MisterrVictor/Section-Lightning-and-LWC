public class myClass { 
  public void init() { 
    Id id = ApexPages.currentPage().getParameters().get('id'); 
    Account obj = [select id, Name FROM Account WHERE id = :id]; 
    delete obj; 
    return ; 
  }
}