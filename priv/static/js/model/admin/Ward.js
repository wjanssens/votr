Ext.define('Votr.model.admin.Ward', {
    extend: 'Ext.data.TreeModel',
    fields: [
        {name: 'version', type: 'int', critical: true},
        {name: 'parent_id', type: 'string'},
        {name: 'ext_id', type: 'string'},
        {name: 'seq', type: 'integer'},
        {name: 'names'},
        {name: 'descriptions'},
        {name: 'start_time', type: 'date'},
        {name: 'end_time', type: 'date'},
        {
            name: 'text', type: 'string', depends: ['names', 'version', 'ext_id'], calculate: function (data) {
                return `${data.names == null ? '' : data.names.default} (${data.version})`;
            }
        }
    ]
});
