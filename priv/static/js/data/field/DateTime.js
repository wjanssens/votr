/**
 * This class provides Date specific processing for fields.
 *
 * In previous releases this functionality was integral to the `Field` base class.
 */
Ext.define('Votr.data.field.DateTime', {
    extend: 'Ext.data.field.Field',

    alias: 'data.field.datetime',

    sortType: 'asDate',

    // this works as follows:
    // as the user types the values are parsed using one of the valid patterns below
    // when parsing is successful then the value is converted to a string in the human readable format
    // when parsing is unsuccessful then the value is returned as is so the user can continue typing it in
    // when the value is sent to the server it is converted from the human readable format to iso8601

    // this lets the user type in

    convert: (value) => {
        const patterns = [
            // used to parse values typed in by the user
            'Y-m-d G:i P','Y-m-d H:i P','Y-m-d G:i O','Y-m-d H:i O','Y-m-d G:i','Y-m-d H:i',
            // used to parse values returned by the server
            'Y-m-d\\TH:i:s.uu\\Z','Y-m-d\\TH:i:s.u\\Z','Y-m-d\\TH:i:s\\Z'
            // the .uu pattern is a workaround for a bug that prevents parsing nano-second precision
            // the c and C ISO8601 constants are not used because they are too lenient (i.e. just the year is valid)
        ];
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
        return value == null ? null : Ext.Date.format(Ext.Date.parse(value, 'Y-m-d H:i', true), 'C');
    },

    getType: function() {
        return 'datetime';
    }
});
