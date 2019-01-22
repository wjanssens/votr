Ext.define('Votr.store.admin.Wards', {
    extend: 'Ext.data.TreeStore',
    model: 'Votr.model.admin.Ward',
    rootVisible: false,
    parentIdProperty: 'ward_id',
    proxy: {
        type: 'ajax',
        url: '../api/admin/wards',
        reader: {
            type: 'json',
            rootProperty: 'wards'
        }
    },
    autoLoad: true
});
