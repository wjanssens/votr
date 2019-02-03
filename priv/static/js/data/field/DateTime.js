/**
 * This class provides Date specific processing for fields.
 *
 * In previous releases this functionality was integral to the `Field` base class.
 */
Ext.define('Votr.data.field.DateTime', {
    extend: 'Ext.data.field.Field',

    alias: 'data.field.datetime',

    sortType: 'asDate',

    convert: (value) => {
        const patterns = ['Y-m-d G:i P','Y-m-d H:i P','Y-m-d G:i O','Y-m-d H:i O','Y-m-d G:i','Y-m-d G:i','c'];
        let parsed;
        for (let i = 0; i < patterns.length; i++) {
            parsed = Ext.Date.parse(value, patterns[i], true)
            if (parsed != null) {
                break;
            }
        }
        return parsed == null ? value : Ext.Date.format(parsed, 'Y-m-d H:i');
    },
    serialize: (value) => {
        return value == null ? null : Ext.Date.format(Ext.Date.parse(value, 'Y-m-d H:i', true), 'c');
    },

    getType: function() {
        return 'datetime';
    }
});