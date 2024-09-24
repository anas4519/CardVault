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


    const { name, industry, sector, companyName, venue, date, designation, companyAddress, personalAddress, email, website, telephone, mobile, whatsapp, category, user_id, initialNotes, additionalNotes } = req.body;

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
            initialNotes,
            additionalNotes,
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

router.delete('/:id', async (req, res) => {
    const { id } = req.params;

    try {
        const deletedCard = await Card.findByIdAndDelete(id);
        if (!deletedCard) {
            return res.status(404).json({ success: false, message: "Card not found" });
        }

        return res.json({ success: true, message: "Card deleted successfully" });
    } catch (error) {
        console.error('Error deleting card:', error);
        return res.status(500).json({ success: false, message: "Failed to delete card" });
    }
});

router.patch('/:id/initialNotes', async (req, res) => {
    const { id } = req.params; // Get card id from the URL
    const { initialNotes } = req.body; // Get initialNotes from the request body
    try {
        const updatedCard = await Card.findByIdAndUpdate(
            id,
            { initialNotes: initialNotes },
            { new: true }
        );
        if (!updatedCard) {
            return res.status(404).json({ message: 'Card not found' });
        }
        res.status(200).json(updatedCard);
    } catch (error) {
        res.status(500).json({ message: 'Server error', error });
    }
});

router.patch('/:id/additionalNotes', async (req, res) => {
    const { id } = req.params; // Get card id from the URL
    const { additionalNotes } = req.body; // Get initialNotes from the request body
    try {
        const updatedCard = await Card.findByIdAndUpdate(
            id,
            { additionalNotes: additionalNotes },
            { new: true }
        );
        if (!updatedCard) {
            return res.status(404).json({ message: 'Card not found' });
        }
        res.status(200).json(updatedCard);
    } catch (error) {
        res.status(500).json({ message: 'Server error', error });
    }
});


module.exports = router;
