Ext.define('Votr.model.admin.Ward', {
    extend: 'Ext.data.TreeModel',
    requires: [
        'Votr.data.validator.DateTime',
        'Votr.data.field.DateTime'
    ],
    fields: [
        {name: 'version', type: 'int', critical: true},
        {name: 'parent_id', type: 'string'},
        {name: 'ext_id', type: 'string'},
        {name: 'seq', type: 'integer'},
        {name: 'names'},
        {name: 'descriptions'},
        {
            name: 'start_time', type: 'datetime', validators: [
                {type: 'datetime', message: 'Invalid end date/time'}
            ]
        },
        {
            name: 'end_time', type: 'datetime', validators: [
                {type: 'datetime', message: 'Invalid end date/time'}
            ]
        },
        {
            name: 'text', type: 'string', depends: ['names'], calculate:
                function (data) {
                    return `${data.names == null ? '' : data.names.default}`;
                }
        }
    ],
    proxy: {
        type: 'rest',
        url:
            '../api/admin/wards',
        reader:
            {
                type: 'json',
                rootProperty:
                    'wards'
            }
    }
    ,
})
;
