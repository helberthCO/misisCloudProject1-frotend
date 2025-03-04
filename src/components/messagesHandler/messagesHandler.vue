<template>
    <div class="messages-box__container">
        <div class="messages-box__messages">
            <div v-for="(message, index) in messages.RawMessage" :key="index">
                <span :class="['messages-box__message', `messages-box__message--${message.sender}`]">{{ message.text }}</span>
            </div>
            <span v-if="notResponded" class="messages-box__message messages-box__message--assistant messages-box__message--sending">...<span class="dots"></span></span>
        </div>
        <form class="messages-box__bubble" @submit.prevent="sendMessage">
            <Input class="messages-box__input" type="text" v-model="message" :notResponded="notResponded" placeholder="Escribe un mensaje" required />
            <Button class="messages-box__send" type="submit" :disabled="notResponded">></Button>
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
        },
        sender: {
            type: String,
            required: true
        }
    },
    data() {
        return {
            message: '',
            notResponded: false,
            checkUnreadMessagesInterval: null
        };
    },
    methods: {
        async sendMessage() {
            const token = sessionStorage.getItem("token");
            const messageBody = {
                text: this.message,
                sender: 'user'
            };

            this.notResponded = true;

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
                    this.startCheckingUnreadMessages();
                } else {
                    console.error("Error al enviar el mensaje");
                }
            } catch (error) {
                console.error(`Error: ${error.message}`);
            }
        },
        startCheckingUnreadMessages() {
            if (this.checkUnreadMessagesInterval) {
                clearInterval(this.checkUnreadMessagesInterval);
            }

            this.checkUnreadMessagesInterval = setInterval(this.checkUnreadMessages, 300);
        },
        async checkUnreadMessages() {
            const token = sessionStorage.getItem("token");

            try {
                const response = await fetch(`http://127.0.0.1:8080/chats/${this.chatId}/unread`, {
                    method: "GET",
                    headers: {
                        "Authorization": `Bearer ${token}`
                    }
                });

                if (response.ok) {
                    const data = await response.json();
                    if (data.unread) {
                        this.notResponded = true;
                        this.markAsRead();
                        this.$emit('message-sent');
                    } else {
                        this.notResponded = false;
                        clearInterval(this.checkUnreadMessagesInterval);
                    }
                }
            } catch (error) {
                console.error(`Error: ${error.message}`);
            }
        },
        async markAsRead() {
            const token = sessionStorage.getItem("token");

            try {
                const response = await fetch(`http://127.0.0.1:8080/chats/${this.chatId}/mark-as-read`, {
                    method: "POST",
                    headers: {
                        "Authorization": `Bearer ${token}`
                    }
                });
            } catch (error) {
                console.error(`Error: ${error.message}`);
            }
        }
    },
    beforeDestroy() {
        if (this.checkUnreadMessagesInterval) {
            clearInterval(this.checkUnreadMessagesInterval);
        }
    }
};
</script>

<style lang="scss" scoped>
@use './messagesHandler.scss';
</style>