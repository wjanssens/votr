Ext.define('Votr.model.admin.Ward', {
    extend: 'Ext.data.TreeModel',
    fields: [
        {name: 'ward_id', type: 'integer'},
        {
            name: 'text', type: 'string', depends: ['names'], calculate: function (data) {
                return data.names == null ? '' : data.names.default;
            }
        },
        {name: 'names'},
        {name: 'descriptions'},
        {name: 'ext_id', type: 'string'},
        {name: 'start_time', type: 'date'},
        {name: 'end_time', type: 'date'}
    ]
});
