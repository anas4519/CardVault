const { Router } = require("express");
const multer = require("multer");
const path = require("path");
const { Card } = require("../models/card");
const { User } = require("../models/user");

const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, path.resolve(`./public/cards/`));
    },
    filename: function (req, file, cb) {
        const fileName = `${Date.now()}-${file.originalname}`;
        cb(null, fileName);
    }
});

const upload = multer({ storage: storage });
const router = Router();

router.post("/", upload.single("cardImage"), async (req, res) => {
    console.log(req.body);

    if (!req.file) {
        return res.status(400).json({ success: false, message: "No file uploaded" });
    }

    
    const { name, industry, sector, companyName, venue, date, designation, companyAddress, personalAddress, email, website, telephone, mobile, whatsapp, category, user_id } = req.body;

    try {
        const user = await User.findById(user_id);
        if (!user) {
            return res.status(404).json({ success: false, message: "User not found" });
        }

        const card = await Card.create({
            name,
            industry,
            sector,
            companyName,
            venue,
            date,
            designation,
            companyAddress,
            personalAddress,
            email,
            website,
            telephone,
            mobile,
            whatsapp,
            category,
            createdBy: user._id,
            cardImage: `/cards/${req.file.filename}`
        });
        
        return res.json({ success: true, card });
    } catch (error) {
        console.error(error);
        return res.status(500).json({ success: false, message: "Failed to create card" });
    }
});

router.get('/user/:createdBy', async (req, res) => {
    try {
        const { createdBy } = req.params;

        const allCards = await Card.find({ createdBy })
            .sort({ createdAt: -1 })
            
        return res.json(allCards);
    } catch (error) {
        console.error('Error fetching cards:', error);
        return res.status(500).json({ error: 'Internal server error' });
    }
});

module.exports = router;