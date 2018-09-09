Ext.define('Votr.model.Ward', {
    extend: 'Ext.data.Model',
    fields: [
        {name: 'ward_id', type: 'integer'},
        {name: 'name', type: 'string'},
        {name: 'description', type: 'string'},
        {name: 'ext_id', type: 'string'},
        {name: 'start_time', type: 'date'},
        {name: 'end_time', type: 'date'}
    ]
});
