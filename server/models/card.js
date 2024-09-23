const {Schema, model} = require("mongoose");

const cardSchema = new Schema({
    name: {
        type:String,
        required: true
    },
    industry: {
        type: String,
        required: true,
    },
    sector: {
        type: String,
        required: true,
    },
    companyName: {
        type: String,
        required: true,
    },
    venue: {
        type: String,
        required: true,
    },
    date: {
        type: String,
        required: true,
    },
    designation: {
        type: String,
    },
    companyAddress: {
        type: String,
        
    },
    personalAddress: {
        type: String,
        
    },
    email: {
        type: String,
        
    },
    website: {
        type: String,
        
    },
    telephone: {
        type: String,
        
    },
    mobile: {
        type: String,
        
    },
    whatsapp: {
        type: String,
        
    },
    category: {
        type: String,
        
    },
    cardImage: {
        type: String,
        required: true
    },
    createdBy: {
        type: Schema.Types.ObjectId,
        ref: "user"
    }

},{timestamps: true})

const Card = model("card", cardSchema)
module.exports = {Card};