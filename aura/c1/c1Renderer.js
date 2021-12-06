({
    render: function(cmp, helper) {
       console.log('render');
       helper.changeValueRender(cmp);
       return this.superRender()
    },
    rerender: function(cmp, helper) {
        console.log('rerender'); 
        return this.superRerender()
    },
})