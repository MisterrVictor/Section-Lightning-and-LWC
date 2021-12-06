({
    update : function(component, event, helper) {
        alert('button clicked');
        component.set("v.text","Changed value after Rerender");
        component.set("v.show","false");
    } 
})