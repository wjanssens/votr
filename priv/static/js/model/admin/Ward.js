Ext.define('Votr.model.admin.Ward', {
    extend: 'Ext.data.TreeModel',
    requires: [
        'Votr.data.validator.DateTime',
        'Votr.data.field.DateTime'
    ],
    fields: [
        {name: 'version', type: 'int', critical: true},
        {name: 'parent_id', type: 'string'},
        {name: 'type', type: 'string'},
        {name: 'ext_id', type: 'string'},
        {name: 'type', type: 'string'},
        {name: 'seq', type: 'integer'},
        {name: 'names'},
        {name: 'descriptions'},
        {name: 'start_at', type: 'datetime'},
        {name: 'end_at', type: 'datetime'},
        {
            name: 'text', type: 'string', depends: ['names'], calculate:
                function (data) {
                    return `${data.names == null ? '' : data.names.default}`;
                }
        },
        {name: 'ward_ct', type: 'integer'},
        {name: 'voter_ct', type: 'integer'},
        {name: 'ballot_ct', type: 'integer'},
        {name: 'updated_at', type: 'datetime'}
    ],
    proxy: {
        type: 'rest',
        url: '../api/admin/wards',
        reader: { type: 'json', rootProperty: 'wards' }
    }
})
;
