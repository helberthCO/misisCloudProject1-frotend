<template>
    <div class="messages-box__container">
        <div class="messages-box__messages">
            <div v-for="(message, index) in messages.RawMessage" :key="index">
                <span class="messages-box__message">{{ message.text }}</span>
            </div>
        </div>
        <form class="messages-box__bubble" @submit.prevent="sendMessage">
            <Input class="messages-box__input" type="text" v-model="message" placeholder="Escribe un mensaje" required />
            <Button class="messages-box__send" type="submit">></Button>
        </form>
    </div>
</template>

<script>
import Input from '../Input/Input.vue';
import Button from '../Button/Button.vue';

export default {
    name: 'messagesHandler',
    components: {
        Input,
        Button
    },
    props: {
        chatId: {
            type: String,
            required: true
        },
        messages: {
            type: Array,
            required: true
        }
    },
    data() {
        return {
            message: ''
        };
    },
    methods: {
        async sendMessage() {
            const token = sessionStorage.getItem("token");
            const messageBody = {
                text: this.message,
                sender: 'user'
            };

            try {
                const response = await fetch(`http://127.0.0.1:8080/chats/${this.chatId}/messages`, {
                    method: "POST",
                    headers: {
                        "Authorization": `Bearer ${token}`,
                        "Content-Type": "application/json"
                    },
                    body: JSON.stringify(messageBody)
                });

                if (response.ok) {
                    this.message = '';
                    this.$emit('message-sent');
                } else {
                    console.error("Error al enviar el mensaje");
                }
            } catch (error) {
                console.error(`Error: ${error.message}`);
            }
        }
    }
};
</script>

<style lang="scss" scoped>
@use './messagesHandler.scss';
</style>