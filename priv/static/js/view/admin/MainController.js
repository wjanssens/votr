Ext.define('Votr.view.admin.MainController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.admin.main',

    onHome() {
        this.redirectTo('#wards');
    }

});