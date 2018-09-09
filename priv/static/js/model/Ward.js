Ext.define('Votr.model.Ward', {
    extend: 'Ext.data.TreeModel',
    fields: [
        {name: 'ward_id', type: 'integer'},
        {name: 'text', calculate: function(data) { return data.name == null ? '' : data.name.default; }, depends: [ 'name' ]},
        {name: 'name'},
        {name: 'description'},
        {name: 'ext_id', type: 'string'},
        {name: 'start_time', type: 'date'},
        {name: 'end_time', type: 'date'}
    ]
});
