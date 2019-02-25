Ext.define('Votr.store.Colors', {
    extend: 'Ext.data.Store',
    model: 'Votr.model.Color',
    sorters: ['hue'],
    data: [
        {hue: 0,   value: '#f43636', dark: "#d32f2f", light: "#ffcdcd", text: 'Red'},
        {hue: 340, value: '#e91e63', dark: "#c21851", light: "#f8bbcf", text: 'Crimson'},
        {hue: 290, value: '#9927b0', dark: "#8c1fa2", light: "#e0bee7", text: 'Purple'},
        {hue: 260, value: '#643ab7', dark: "#562da8", light: "#d0c4e9", text: 'Violet'},
        {hue: 230, value: '#3f53b5', dark: "#30439f", light: "#c5cbe9", text: 'Sapphire'},
        {hue: 210, value: '#218af3', dark: "#1976d2", light: "#bbdbfb", text: 'Azure'},
        {hue: 200, value: '#03a4f4', dark: "#028cd1", light: "#b3e4fc", text: 'Cerulean'},
        {hue: 185, value: '#00c2d4', dark: "#0099a7", light: "#b2edf2", text: 'Cyan'},
        {hue: 170, value: '#00967d', dark: "#007965", light: "#b2dfd7", text: 'Teal'},
        {hue: 120, value: '#4caf4c', dark: "#388e38", light: "#c8e6c8", text: 'Green'},
        {hue: 85,  value: '#91c34a', dark: "#749f38", light: "#deedc8", text: 'Chartreuse'},
        {hue: 70,  value: '#c1dc39', dark: "#9db42b", light: "#ecf4c3", text: 'Lime'},
        {hue: 55,  value: '#ffef3b', dark: "#fbc72d", light: "#fffac4", text: 'Yellow'},
        {hue: 45,  value: '#ffc107', dark: "#ffaa00", light: "#ffecb3", text: 'Amber'},
        {hue: 35,  value: '#ff9500', dark: "#f57b00", light: "#ffdfb2", text: 'Orange'},
        {hue: 15,  value: '#ff5922', dark: "#e64c19", light: "#ffcdbc", text: 'Vermilion'},
        {hue: 15,  value: '#795448', dark: "#5d4137", light: "#d7ccc8", text: 'Brown'},
        {hue: -1,  value: '#9e9e9e', dark: "#616161", light: "#F5F5F5", text: 'Grey'},
        {hue: 200, value: '#607d8b', dark: "#455a64", light: "#cfd8dc", text: 'Blue Grey'}
    ]
});
