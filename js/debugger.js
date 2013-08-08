/**
 * Created with JetBrains PhpStorm.
 * User: qngo
 * Date: 8/7/13
 * Time: 7:20 PM
 * To change this template use File | Settings | File Templates.
 */
var deb = (function() {

    var me = {
        init : function() {
        },
        trace : function(val1, val2)
        {
          trace(val1, val2, arguments);
        }
    };

    function trace(val1, val2) {
        console.log('-@@-', val1, arguments);
    }

    return me;
})();

console.log('deb loaded');
