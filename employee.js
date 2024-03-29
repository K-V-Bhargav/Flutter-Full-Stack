const mongoose = require("mongoose");

const personSchema = new mongoose.Schema({
    'pname': {
        type: String,
        required: true,
    },
    'pphone': {
        type: String,
        required: true,
    },
    'page': {
        type: String,
        required: true,
    },
});

module.exports = mongoose.model("node_js", personSchema);