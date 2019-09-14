Ext.define('Votr.view.admin.ResultsController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.admin.results',

    init: function(view) {
        this.getViewModel().bind('{id}', this.onNavigate, this);
    },

    onNavigate: function(id) {
        this.getViewModel().getStore('resultRounds').load({
            scope: this,
            callback: function(records, operation, success) {
                if (records.length > 0) {
                    const list = this.lookupReference('resultRoundsList');
                    list.setSelection(records[0]);
                }
            }
        });
    }

});
