Ext.define('Votr.view.admin.DashboardController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.admin.dashboard',

    onWards: function() {
        const list = this.lookupReference('wardList');
        const selection = list.getSelection();
        this.redirectTo(`#wards/${selection.get('id')}`)
    },

    onPolls: function() {
        const list = this.lookupReference('wardList');
        const selection = list.getSelection();
        this.redirectTo(`#wards/${selection.get('id')}/voters`)
    },

    onCounts: function() {
        const list = this.lookupReference('wardList');
        const selection = list.getSelection();
        this.redirectTo(`#wards/${selection.get('id')}/ballots`)
    }
});