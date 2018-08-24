Ext.define('Votr.view.ElectorController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.elector',

    onHome() {
        this.redirectTo('#wards');
    }

});